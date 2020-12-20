#!/usr/bin/env python3
import xml.dom.minidom
import base64
from xml.etree import ElementTree as et
import sys

fname = sys.argv[1]


dom = xml.dom.minidom.parse(fname) # or xml.dom.minidom.parseString(xml_string)
# breakpoint()
# dom.getElementsByTagName('document')[0] = 'XXX'
doc = dom.getElementsByTagName('document')[0]
# breakpoint()
doc_decoded = base64.b64decode(doc.childNodes[0].nodeValue)
print(xml.dom.minidom.parseString(doc_decoded).toprettyxml(indent='  '))
# xml.dom.minidom.parseString(doc_decoded)
# doc.childNodes[0].nodeValue = doc_decoded
# pretty_xml_as_string = dom.toprettyxml()
# print(pretty_xml_as_string)
