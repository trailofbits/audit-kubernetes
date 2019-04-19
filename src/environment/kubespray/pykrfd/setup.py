from setuptools import setup, find_packages
setup(
    name='krfd',
    version='0.0.1',
    description='A library for controlling distributed krf fuzzing.',
    packages=find_packages(),
    scripts=['scripts/krfd']
)
