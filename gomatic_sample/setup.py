from setuptools import find_packages, setup

setup(name='gomatic_sample',
      version='0.0.1',
      description='Sample pipeline using Gomatic',
      url='https://github.com/akshaykarle/gocd-docker',
      author='Akshay Karle',
      author_email='',
      license='MIT',
      packages=find_packages(exclude=('tests', 'docs')))
