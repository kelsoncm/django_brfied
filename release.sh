#!/usr/bin/env bash

if [ $# -eq 0 ]
  then
    echo "NAME
       release

SYNOPSIS
       ./release.sh [-d|-p|-g] <version>

DESCRIPTION
       Create a new release to django_brfied python package.

OPTIONS
       -d         Deploy to Github and PyPI
       -p         Deploy to PyPI
       -g         Deploy to Github
       <version>  Release version number

EXAMPLES
       o   Build to local usage only:
                  ./release.sh 1.1
       o   Build and deploy to both Github and PyPI:
                  ./release.sh -d 1.1
       o   Build and deploy to PyPI only:
                  ./release.sh -p 1.1
       o   Build and deploy to Github only:
                  ./release.sh -g 1.1
"
fi


create_setup_cfg_file() {
    echo """# -*- coding: utf-8 -*-
from distutils.core import setup
setup(
    name='django_brfied',
    description='Django Application specific brazilian fields types',
    long_description='Utils classes for EGE project',
    license='MIT',
    author='Kelson da Costa Medeiros',
    author_email='kelsoncm@gmail.com',
    packages=['django_brfied', 'django_brfied/migrations', 'django_brfied/management/commands', 'django_brfied/static', ],
    package_data = {'static': ['*'], },
#    package_dir={'django_brfied': 'django_brfied'},
#    packages=['ege_theme', 'ege_theme/migrations', 'ege_theme/static', 'ege_theme/templates', 'ege_theme/templatetags'],
    include_package_data=True,
    version='$1',
    download_url='https://github.com/kelsoncm/django_brfied/releases/tag/$1',
    url='https://github.com/kelsoncm/django_brfied',
    keywords=['django', 'BR', 'Brazil', 'Brasil', 'model', 'form', 'locale', ],
    classifiers=[]
)
""" > setup.py
    docker build -t kelsoncm/django_brfied --force-rm .
    docker run --rm -it -v `pwd`:/src kelsoncm/django_brfied python setup.py sdist
}

if [[ $# -eq 1 ]]
  then
    echo "Build to local usage only. Version: $1"
    echo ""
    create_setup_cfg_file $1
fi

if [[ $# -eq 2 ]] && [[ "$1" == "-d" || "$1" == "-g" || "$1" == "-p" ]]
  then
    echo "Build to local. Version: $2"
    echo ""
    create_setup_cfg_file $2

    if [[ "$1" == "-d" || "$1" == "-g" ]]
      then
        echo ""
        echo "GitHub: Pushing"
        echo ""
        git add setup.py
        git commit -m "Release $2"
        git tag $2
        git push --tags origin master
    fi

    if [[ "$1" == "-d" || "$1" == "-p" ]]
      then
        echo ""
        echo "PyPI Hub: Uploading"
        echo ""
        docker run --rm -it -v `pwd`:/src kelsoncm/django_brfied twine upload dist/django_brfied-$2.tar.gz
    fi
fi

echo ""
echo "Done."
