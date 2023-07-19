# Copyright (c) Microsoft Corporation.
# Licensed under the MIT license.

import sys
if sys.version_info < (2, 7):
    import unittest2 as unittest
else:
    import unittest


def alltests():
    ret = unittest.TestLoader().discover('test/')
    return ret


if __name__ == '__main__':
    unittest.main(verbosity=0)
