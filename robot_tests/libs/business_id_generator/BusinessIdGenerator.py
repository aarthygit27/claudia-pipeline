# -*- coding: UTF-8 -*-
from __future__ import absolute_import

from random import randint


class BusinessIdGenerator(object):
    """ This Robot Framework library generates Business ID's used in Finland.

    """

    ROBOT_LIBRARY_SCOPE = 'GLOBAL'

    def generate_business_id(self):
        """ Generates randomized valid Finnish business id. All generated business id's will start with number 7 because they
         aren't assigned to any companies at the moment.
        """
        check = ""
        value = self._generate_base()
        try:
            check = self._validate(value)
        except InvalidBusinessIdException:
            return self.generate_business_id()
        if len(check) == 0:
            return self.generate_business_id()
        return value + "-" + str(check)

    def _validate(self, string):
        sum_ = sum([x * y for x, y in zip([int(i) for i in string], [7, 9, 10, 5, 8, 4, 2])])
        mod_ = sum_ % 11
        if not mod_:
            return str(mod_)
        if mod_ == 1:
            raise InvalidBusinessIdException('Invalid Business Id')
        return str(11 - mod_)

    def _randomize(self, n):
        range_start = 10 ** (n - 1)
        range_end = (10 ** n) - 1
        return randint(range_start, range_end)

    def _generate_base(self):
        random = self._randomize(6)
        return str(7000000 + random)


class InvalidBusinessIdException(Exception):
    pass
