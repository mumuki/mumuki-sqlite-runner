#!/usr/bin/python
# -*- coding: utf-8 -*-

import json
import unittest
from mql import *


class TestMQL(unittest.TestCase):

    def setUp(self):
        self.init = "CREATE TABLE test (\nid INTEGER PRIMARY KEY,\nname VARCHAR(200) NOT NULL\n);"
        self.student = "SELECT * FROM test;"
        self.seed1 = "INSERT INTO test (name) VALUES ('Test 1.1');\nINSERT INTO test (name) VALUES ('Test 1.2');\nINSERT INTO test (name) VALUES ('Test 1.3');"
        self.seed2 = "INSERT INTO test (name) VALUES ('Test UTF-8 áéíóúñÁÉÍÓÚÑ');"
        self.expected_ok = "SELECT name FROM test;"
        self.expected_error = "SELECT name FROM test"

    def test_run_ok(self):
        # Arrange
        content = json.dumps({
            'init': self.init,
            'student': self.student,
            'tests': [
                {
                    'seed': self.seed1,
                    'expected': self.expected_ok
                },
                {
                    'seed': self.seed2,
                    'expected': self.expected_ok
                }
            ]
        })

        # Act
        mql = MQL(json.loads(content)).run()
        result = mql.get_result()

        # Assert
        self.assertFalse(mql.has_error())
        self.assertEquals(2, len(result['expected']))
        self.assertEquals(2, len(result['student']))
        self.assertEquals("name\nTest 1.1\nTest 1.2\nTest 1.3", result['expected'][0])
        self.assertEquals("name\nTest UTF-8 áéíóúñÁÉÍÓÚÑ", result['expected'][1])
        self.assertEquals("id|name\n1|Test 1.1\n2|Test 1.2\n3|Test 1.3", result['student'][0])
        self.assertEquals("id|name\n1|Test UTF-8 áéíóúñÁÉÍÓÚÑ", result['student'][1])

    def test_run_error(self):
        # Arrange
        content = json.dumps({
            'init': self.init,
            'student': self.student,
            'tests': [
                {
                    'seed': self.seed1,
                    'expected': self.expected_error
                }
            ]
        })

        # Act
        mql = MQL(json.loads(content)).run()
        error = mql.get_error()

        # Assert
        self.assertTrue(mql.has_error())
        self.assertEquals(1, error['code'])
        self.assertEquals("Error: incomplete SQL: SELECT name FROM test", error['output'])


if __name__ == '__main__':
    unittest.main()
