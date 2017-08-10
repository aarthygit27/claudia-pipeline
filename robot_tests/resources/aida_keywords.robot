*** Settings ***
Library                 Selenium2Library
Library                 libs.selenium_extensions.SeleniumExtensions.SeleniumExtensions
Resource                ${PROJECTROOT}${/}resources${/}common.robot


*** Variables ***
${AIDA_SERVER}          http://jb151tstfin01.ddc.teliasonera.net:9080/AidaWeb/index.html