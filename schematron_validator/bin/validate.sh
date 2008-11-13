#!/bin/sh

my_schema=$1
my_document=$2

xsltproc iso_impl/iso_dsdl_include.xsl $my_schema | \
xsltproc iso_impl/iso_abstract_expand.xsl - | \
xsltproc iso_impl/iso_svrl.xsl - | \
xsltproc - $my_document