import unittest
import vim_my as sut


@unittest.skip("Don't forget to test!")
class VimMyTests(unittest.TestCase):

    def test_example_fail(self):
        result = sut.vim_my_example()
        self.assertEqual("Happy Hacking", result)
