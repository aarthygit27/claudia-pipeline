# -*- coding: UTF-8 -*-
from unittest import TestCase

from libs.selenium_extensions.SeleniumExtensions import SeleniumExtensions


class SkipLibraryInitializationWitLibDocTestCase(TestCase):
    def runTest(self):
        self.lib = SeleniumExtensions('USE_LIBDOC')
        self.assertNotEqual(self.lib, None)
