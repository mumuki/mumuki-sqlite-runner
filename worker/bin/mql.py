#!/usr/bin/python
# -*- coding: utf-8 -*-

from subprocess import *

""" Receive a dictionary like this:

program = {
    'init': "create table ...;\ninsert into ...;",
    'solution': "select ... from ...;",
    'dataset': [
        "insert into ...;",
        "insert into ...;"
    ],
    'student': "select ... from ...;"
}

And Run sqlite3 with an empty mumuki database.

Example:
    clean mumuki database
    run 'init'
    run 'dataset'[0]
    run 'solution'
    run 'student'
    
    clean mumuki database
    run 'init'
    run 'dataset'[1]
    run 'solution'
    run 'student'
    
    ...


Output expected if success:

{
    'solutions': [
        'id|name|...\n1|test1|...\n1|test2|...\',
        'id|name|...\n1|bla1|...\n1|bla2|...\',
    ],
    'results': [
        'id|name|...\n1|test1|...\n1|test2|...\',
        'id|name|...\n1|bla1|...\n1|bla2|...\',
    ],
}


Output expected if error:

{
    'error': 'Error descriptions...'
}
"""

DATABASE = 'mumuki.sqlite'


def rm(filename):
    call(['rm', '-f', filename])


def clean_all():
    map(clean, [DATABASE, 'init.sql', 'dataset.sql', 'solution.sql', 'student.sql'])


def clean(file):
    rm(file)
    call(['touch', file])


def dump(name, content):
    file = open(name + '.sql', 'w')
    file.write(content + '\n')
    file.close()


class RunException(Exception):
    def __init__(self, message):
        self.message = message


def command(filename):
    return 'sqlite3 {db} < {file}.sql'.format(db=DATABASE, file=filename)


class MQL:
    def __init__(self, code):
        self.code = code
        self.result = {
            'solutions': [],
            'results': [],
        }

    def has_error(self):
        return 'error' in self.result

    def get_error(self):
        return self.result['error']

    def get_result(self):
        return self.result

    def dump(self, name):
        dump(name, self.code[name])

    def run(self):
        clean_all()
        self.dump('init')
        self.dump('solution')
        self.dump('student')

        if not self.code['datasets']:
            self.code['datasets'] = ["-- none"]

        for dataset in self.code['datasets']:
            try:
                dump('dataset', dataset)
                self.run_solution()
                self.run_student()
            except RunException:
                clean_all()
                return self

        clean_all()
        self.post_process()
        return self

    def prepare_db(self):
        clean(DATABASE)
        self._run('init')
        self._run('dataset')

    def run_solution(self):
        self.prepare_db()
        self._run('solution')

    def run_student(self):
        self.prepare_db()
        self._run('student')

    def _run(self, param):
        try:
            output = check_output(command(param), stderr=STDOUT, shell=True)
        except CalledProcessError as e:
            self.result['error'] = {
                'code': e.returncode,
                'output': e.output.strip(),
            }
            raise RunException('Error: ' + e.output)
        else:
            if param == 'solution':
                self.result['solutions'].append(output)
            elif param == 'student':
                self.result['results'].append(output)
            else:
                pass

    def post_process(self):
        self.result['solutions'] = map(str.strip, self.result['solutions'])
        self.result['results'] = map(str.strip, self.result['results'])
