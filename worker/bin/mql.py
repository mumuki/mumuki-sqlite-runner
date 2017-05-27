#!/usr/bin/python

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


def rm(filename):
    call(['rm', '-f', filename])


def clean_all():
    rm('mumuki')
    rm('init.sql')
    rm('dataset.sql')
    rm('solution.sql')
    rm('student.sql')


def clean_database():
    rm('mumuki')
    call(['touch', 'mumuki'])


def dump(name, content):
    file = open(name + '.sql', 'w')
    file.write(content + '\n')
    file.close()


class RunException(Exception):
    def __init__(self, message):
        self.message = message


def command(filename):
    return 'sqlite3 mumuki < {}.sql'.format(filename)


def list_to_dict(list):
    return {key: value for key, value in enumerate(list)}


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
        self.dump('init')
        self.dump('solution')
        self.dump('student')

        if not self.code['datasets']:
            self.code['datasets'] = ["-- none"]

        for dataset in self.code['datasets']:
            try:
                dump('dataset', dataset)
                self.run_dataset()
            except RunException:
                clean_all()
                return self

        clean_all()
        self.post_process()
        return self

    def run_dataset(self):
        clean_database()
        self._run('init')
        self._run('dataset')
        self._run('solution')
        self._run('student')

    def _run(self, param):
        try:
            output = check_output(command(param), stderr=STDOUT, shell=True)
        except CalledProcessError as e:
            self.result['error'] = {
                'code': e.returncode,
                'output': e.output,
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
        self.result['solutions'] = list_to_dict(self.result['solutions'])
        self.result['results'] = list_to_dict(self.result['results'])
