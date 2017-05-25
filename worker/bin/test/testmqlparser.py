import unittest
from mqlparser import *


class TestMQLParser(unittest.TestCase):
    # Format: -- #tagname
    # Tags: init, student, solutions
    def test_is_tag(self):
        self.assertTrue(is_tag('-- #init'))
        self.assertTrue(is_tag('-- #INIT'))
        self.assertTrue(is_tag('-- #student'))
        self.assertTrue(is_tag('-- #solution'))

        self.assertFalse(is_tag('- #solution'))
        self.assertFalse(is_tag('-- init'))
        self.assertFalse(is_tag('-- dataset'))
        self.assertFalse(is_tag('select * from bla;'))

    # Only is valid: -- DATASET
    def test_is_dataset(self):
        self.assertTrue(is_dataset('-- DATASET'))
        self.assertTrue(is_dataset('-- dataset'))

        self.assertFalse(is_dataset('-- #solution'))
        self.assertFalse(is_dataset('select * from bla;'))

    # PRE: should be a valid tag
    def test_get_tag(self):
        self.assertEqual('init', get_tag('-- #init'))
        self.assertEqual('init', get_tag('-- #INIT'))

    def test_mql_parser(self):
        content = [
            '-- #init\n',
            'create table ...;\n',
            'insert into ...;\n',
            '-- #solution\n',
            'select ... from ...;\n',
            '-- DATASET\n',
            'insert into table1;\n',
            '-- DATASET\n',
            'insert into table2;\n',
            '-- #student\n',
            'select ... from ...;'
        ]

        parser = MQLParser(content)
        parser.compile()
        self.assertFalse(parser.has_error())
        code = parser.get_code()

        self.assertEquals("create table ...;\ninsert into ...;", code['init'])
        self.assertEquals("select ... from ...;", code['solution'])
        self.assertEquals("select ... from ...;", code['student'])
        self.assertEquals(2, len(code['datasets']))
        self.assertEquals("insert into table1;", code['datasets'][0])
        self.assertEquals("insert into table2;", code['datasets'][1])


if __name__ == '__main__':
    unittest.main()
