#!/usr/bin/python
# -*- coding: utf-8 -*-

from subprocess import *

""" Receives a dictionary like this:
data = {
    'init': "CREATE TABLE ...;\nINSERT INTO ...;",
    'student': "SELECT ... FROM ...;"
    'tests': [{
        'seed': "INSERT INTO ...;\nINSERT INTO ...",
        'expected': "SELECT * FROM ...;"
    },{
        'seed': "INSERT INTO ...;\nINSERT INTO ...",
        'expected': "-- NONE"
    }],
}

Then run:
    for test in data['tests']:
        clean database
        run data['init']
        run test['seed']
        run test['expected'] >> response['expected']
        
        clean database
        run data['init']
        run test['seed']
        run data['student'] >> response['student']

And return:
response = {
    'expected': [
        'id|name|...\n1|test1|...\n1|test2|...\',
        'id|name|...\n1|bla1|...\n1|bla2|...\',
    ],
    'student': [
        'id|name|...\n1|test1|...\n1|test2|...\',
        'id|name|...\n1|bla1|...\n1|bla2|...\',
    ],
}

If error:
response = {
    "output": "Error: incomplete SQL: SELECT name FROM test",
    "code": 1
}
"""

# Constants
EXT = '.sql'
FILES = {
    'db': 'mumuki.sqlite',
    'init': 'init.sql',
    'seed': 'seed.sql',
    'student': 'student.sql',
    'expected': 'expected.sql',
}


def clean(file):
    rm(file)
    call(['touch', file])


def clean_db():
    clean(FILES['db'])


def rm_all():
    map(rm, FILES.values())


def rm(filename):
    call(['rm', '-f', filename])


def dump(content, filename):
    content = content if content else "-- NONE"
    clean(filename)
    file = open(filename, 'w')
    file.write(content.encode('utf8') + '\n')
    file.close()


def dump_data(data, name):
    dump(data[name], FILES[name])


class RunException(Exception):
    def __init__(self, message):
        self.message = message


def command(filename):
    return 'sqlite3 {db} < {file}.sql'.format(db=FILES['db'], file=filename)


class MQL:
    def __init__(self, data):
        self.data = data
        self.response = {'expected': [], 'student': []}

    def run(self):
        self.dump('init')
        self.dump('student')
        for test in self.data['tests']:
            dump_data(test, 'seed')
            dump_data(test, 'expected')
            try:
                self.prepare_db()
                self._run('expected')
                self.prepare_db()
                self._run('student')
            except RunException:
                break
        rm_all()
        self.post_process()
        return self

    def prepare_db(self):
        clean_db()
        self._run('init')
        self._run('seed')

    def _run(self, param):
        try:
            output = check_output(command(param), stderr=STDOUT, shell=True)
        except CalledProcessError as e:
            self.response['error'] = {
                'code': e.returncode,
                'output': e.output.strip(),
            }
            raise RunException('Error: ' + e.output)
        else:
            if param in ['expected', 'student']:
                self.response[param].append(output)
            else:
                pass

    def post_process(self):
        for name in ['expected', 'student']:
            self.response[name] = map(str.strip, self.response[name])

    def has_error(self):
        return 'error' in self.response

    def get_error(self):
        return self.response['error']

    def get_result(self):
        return self.response

    def dump(self, name):
        dump(self.data[name], FILES[name])
