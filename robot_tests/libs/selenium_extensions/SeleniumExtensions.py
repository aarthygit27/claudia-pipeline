# -*- coding: UTF-8 -*-
import platform
import random
import sys
import time

from robot.libraries.BuiltIn import BuiltIn


class SeleniumExtensionsException(Exception):
    pass

class SeleniumExtensions(object):
    """ This Robot Framework library is used to extend Selenium2library with custom keywords.

    """

    ROBOT_LIBRARY_SCOPE = 'GLOBAL'

    def __init__(self, use_libdoc=False):
        if use_libdoc:
            return

        self._selenium2lib = BuiltIn().get_library_instance('Selenium2Library')

    def clickElementWithOnclickEvent(self, locator):
        """Finds element by locator and take its onclick-event action and runs it.

        """
        element = self._element_find(locator, True, True)
        js = element.getAttribute('onclick')
        self._selenium2lib.javaScript.executeJavascript(js)

    def indexForColumnByHeaderContent(self, headers, value):

        elements = self._element_find(headers, False, False)
        index = -1
        for i, elem in enumerate(elements):
            if elem.text.strip() == value:
                index = i + 1
                break

        return index

    def loopTableRowsAndMatchColumnContent(self, xpath_for_rows, index, value):
        elements = self._element_find(xpath_for_rows, False, False)
        for i, elem in enumerate(elements):
            xpath_for_column = xpath_for_rows + "[%s]//td[%s]" % (i + 1, index)
            if value.lower() in self._element_find(xpath_for_column, True, True).text.lower():
                break
        else:
            BuiltIn().fail("Could not find %s from rows" % value)

    def rowNumberByColumnAndValue(self, xpath_for_rows, value):
        count = -1
        elements = self._element_find(xpath_for_rows, False, False)
        for i, elem in enumerate(elements):
            if value in elem.text:
                count = i + 1
                break
        else:
            BuiltIn().fail("Could not find %s from elements of given xpath" % value)

        return count

    def selectOptionByIndex(self, locator, index):
        element = self._element_find(locator, True, True)
        js = "document.getElementById('%s').selectedIndex='%s';" % (element.get_attribute('id'), index)
        self._selenium2lib.execute_javascript(js)

    def selectRandomOption(self, locator, start_index=1):
        element_id = self._element_find(locator, True, True).get_attribute('id')

        js = "return document.getElementById('%s').length;" % element_id
        length = self._selenium2lib.execute_javascript(js)

        index = random.randint(start_index, int(length) - start_index)
        js = "document.getElementById('%s').selectedIndex='%s';" % (element_id, index)
        self._selenium2lib.execute_javascript(js)

    def getRandomText(self, locator, exlude_titles_include=""):
        elements = self._element_find(locator, False, False)
        titles = []
        value = None
        try:
            for elem in elements:
                if not exlude_titles_include or len(
                        exlude_titles_include) > 0 and not exlude_titles_include in elem.text:
                    titles.append(elem.text)
                value = random.choice(titles)
        except IndexError:
            raise Exception("Can not find any titles from element" + locator)
        return value

    def setCkeEditorContent(self, locator, content):
        iframe = self._element_find(locator, True, True)
        self._selenium2lib._current_browser().switch_to_frame(iframe)

        body = self._selenium2lib._current_browser().find_element_by_tag_name('body')
        body.send_keys(content)

        self._selenium2lib._current_browser().switch_to_default_content()

    def ifPopupExistsWithTextThenClickButton(self, text, button='ok'):
        alertFound = False
        try:
            alert = self._alert()
            if alert:
                if alert.text == text:
                    alertFound = True
                    if button.lower() == 'cancel':
                        alert.dismiss()
                        print "Dismissed popup"
                    else:
                        alert.accept()
                        print "Accepted popup"
                else:
                    raise SeleniumExtensionsException("Text '%s' does not match to '%s'." % (alert.text, text))
        except NoAlertPresentException:
            print "No alert found"
        return alertFound

    @property
    def using_java(self):
        return "_element_find" not in dir(self._selenium2lib)

    def _element_find(self, locator, onlyFirst, required, tag=None):
        if self.using_java:
            elements = self._selenium2lib.runKeyword('elementsFind', [locator, onlyFirst, required, tag])
            if onlyFirst:
                return elements[0]
            return elements
        else:
            return self._selenium2lib._element_find(locator, onlyFirst, required, tag)

    def _click(self, locator):
        if self.using_java:
            self._selenium2lib.element.clickElement(locator)
        else:
            self._selenium2lib._element_find(locator, True, True).click()

    def _input(self, locator, value):
        if self.using_java:
            self._selenium2lib.formElement.inputText(locator, value)
        else:
            self._selenium2lib.input_text(locator, value)

    def _wait(self, locator, timeout, error):
        if self.using_java:
            self._selenium2lib.waiting.waitUntilElementIsVisible(locator, timeout, error)
        else:
            self._selenium2lib._wait_until(timeout, error, self._selenium2lib._is_element_present, locator)

    def _alert(self):
        if self.using_java:
            return self._selenium2lib.browserManagement.getCurrentWebDriver().switchTo().alert()
        else:
            return self._selenium2lib._current_browser().switch_to_alert()

    def _xpath_count(self, expected):
        if self.using_java:
            return self._selenium2lib.element.getMatchingXpathCount(expected)
        else:
            return self._selenium2lib.get_matching_xpath_count(expected)

    def _mouse_down(self, locator):
        if self.using_java:
            self._selenium2lib.element.mouseDown(locator)
        else:
            self._selenium2lib.mouse_down(locator)

    def _wait_until_element_is_visible(self, xpath_for_match, timeout):
        if self.using_java:
            self._selenium2lib.waiting.waitUntilElementIsVisible(xpath_for_match, timeout)
        else:
            self._selenium2lib.wait_until_element_is_visible(xpath_for_match, timeout)

    def _press_key(self, xpath_search_input, key):
        if self.using_java:
            self._selenium2lib.element.pressKey(xpath_search_input, key)
        else:
            self._selenium2lib.press_key(xpath_search_input, key)

    def _send_keys(self, element, value):
        if self.using_java:
            element.sendKeys(value)
        else:
            element.send_keys(value)

    def _get_text(self, locator):
        if self.using_java:
            return self._selenium2lib.element.getText(locator)
        else:
            return self._selenium2lib.get_text(locator)


if platform.system() == 'Java':
    sys.path.append("JavaExtensions.jar")
else:
    from selenium.common.exceptions import NoAlertPresentException
