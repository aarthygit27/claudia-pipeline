# -*- coding: UTF-8 -*-
from unittest import TestCase

from libs.business_id_generator.BusinessIdGenerator import BusinessIdGenerator


class GenerateValidFormatBusinessIdTestCase(TestCase):
    def setUp(self):
        self.generator = BusinessIdGenerator()

    def runTest(self):
        business_id = self.generator.generate_business_id()
        self.assertTrue(len(business_id), 8)
        self.assertTrue('-' in business_id)


class GenerateInValidBusinessIdCheckNumberTestCase(TestCase):
    def setUp(self):
        self.generator = BusinessIdGenerator()

    def runTest(self):
        check = self.generator._validate("1234567")
        self.assertEqual('1', check)

        check = self.generator._validate("6666666")
        self.assertEqual('5', check)

        check = self.generator._validate("7654321")
        self.assertEqual('2', check)
