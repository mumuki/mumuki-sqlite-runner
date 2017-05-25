#!/usr/bin/python

""" Parse inputs like this:

-- #init
create table ...;
insert into ...;
-- #solution
select ... from ...;
-- DATASET
insert into ...;
-- DATASET
insert into ...;
-- #student
select ... from ...;

into dictionary like this:

program = {
    'init': "create table ...;\ninsert into ...;",
    'solution': "select ... from ...;",
    'dataset': [
        "insert into ...;",
        "insert into ...;"
    ],
    'student': "select ... from ...;"
}

if error, dictionary includes 'error' key with description
"""


def is_tag(line):
    str = line.strip()
    return str.startswith('--') and str.replace('--', '').lower().strip() in ['#init', '#student', '#solution']


def is_dataset(line):
    str = line.strip()
    return str.startswith('--') and str.replace('--', '').lower().strip() == 'dataset'


# PRE: is_tag(line)
def get_tag(line):
    return line.replace('--', '').replace('#', '').lower().strip()


class MQLParser:
    def __init__(self, input):
        self.input = input
        self.code = {
            '.trash': "",
            'init': "",
            'student': "",
            'solution': "",
            'datasets': {},
        }

    def has_error(self):
        return 'error' in self.code

    def error(self):
        return self.code['error']

    def get_code(self):
        return self.code

    def compile(self):
        di = 0
        current = '.trash'
        for line in self.input.splitlines():
            line = line.strip()
            if is_tag(line):
                current = get_tag(line)

            elif is_dataset(line):
                current = 'datasets'
                di += 1
                self.code[current][di] = ""

            elif current == 'datasets':
                self.code[current][di] = self.code[current][di] + line + "\n"

            else:
                self.code[current] = self.code[current] + line + "\n"

        self._clean_compiled()

    def _clean_compiled(self):
        del self.code['.trash']
        for key in ['init', 'student', 'solution']:
            self.code[key] = self.code[key].strip()
        for k in self.code['datasets'].keys():
            self.code['datasets'][k] = self.code['datasets'][k].strip()
        self.code['datasets'] = self.code['datasets'].values()
