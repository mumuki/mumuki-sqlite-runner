#!/usr/bin/python
# -*- coding: utf-8 -*-

import json
import unittest
from mql import *


class TestMQL(unittest.TestCase):

    def setUp(self):
        self.create = "create table test (\nid integer primary key,\nname varchar(200) not null\n);"
        self.solution_ok = "select name from test;"
        self.solution_error = "select name from test"
        self.student = "select * from test;"
        self.datasets = [
            "insert into test (name) values ('Test 1.1');\ninsert into test (name) values ('Test 1.2');\ninsert into test (name) values ('Test 1.3');",
            "insert into test (name) values ('Test 2.1');\ninsert into test (name) values ('Test 2.2');\ninsert into test (name) values ('Test 2.3');",
            "insert into test (name) values ('Test UTF-8 áéíóúñÁÉÍÓÚÑ');",
        ]

    def test_run_ok(self):
        # Arrange
        content = json.dumps({
            'init': self.create,
            'solution': self.solution_ok,
            'student': self.student,
            'datasets': self.datasets
        })

        # Act
        mql = MQL(json.loads(content)).run()
        result = mql.get_result()

        # Assert
        self.assertFalse(mql.has_error())
        self.assertEquals(3, len(result['solutions']))
        self.assertEquals(3, len(result['results']))
        self.assertEquals("name\nTest 1.1\nTest 1.2\nTest 1.3", result['solutions'][0])
        self.assertEquals("name\nTest 2.1\nTest 2.2\nTest 2.3", result['solutions'][1])
        self.assertEquals("name\nTest UTF-8 áéíóúñÁÉÍÓÚÑ", result['solutions'][2])
        self.assertEquals("id|name\n1|Test 1.1\n2|Test 1.2\n3|Test 1.3", result['results'][0])
        self.assertEquals("id|name\n1|Test 2.1\n2|Test 2.2\n3|Test 2.3", result['results'][1])
        self.assertEquals("id|name\n1|Test UTF-8 áéíóúñÁÉÍÓÚÑ", result['results'][2])

    def test_run_error(self):
        # Arrange
        content = {
            'init': self.create,
            'solution': self.solution_error,
            'student': self.student,
            'datasets': self.datasets
        }

        # Act
        mql = MQL(content).run()
        error = mql.get_error()

        # Assert
        self.assertTrue(mql.has_error())
        self.assertEquals(1, error['code'])
        self.assertEquals("Error: incomplete SQL: select name from test", error['output'])


if __name__ == '__main__':
    unittest.main()
