# Copyright (c) Microsoft Corporation.
# Licensed under the MIT license.

from setuptools import setup

setup(
    name="msigvm",
    version="2.3.2",
    description="msigvm - Microsoft IGVM format",
    long_description=open("README.md").read(),
    long_description_content_type="text/markdown",
    packages=['igvm', 'igvm.structure'],
    package_data={'igvm': ['acpi/acpi.zip']},
    entry_points={
        'console_scripts': [
            'igvmgen = igvm.igvmgen:main',
        ]},
    test_suite="test.alltests",
    install_requires=[
        "ecdsa",
        "cstruct",
        "ctypeslib2",
        "pyelftools",
        "pytest",
        "cached_property",
        "frozendict",
    ]
)
