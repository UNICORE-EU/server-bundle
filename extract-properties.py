#!/usr/bin/env python
from __future__ import print_function

import sys
import xml.etree.ElementTree as ET

file = sys.argv[1]

#
# identify properties that are no longer used
#
ignored = [
# property names
    'XNJS.tsiclass',
    'container.configfile',
    'coreServices.targetsystemfactory.xnjs.configfile',
    'coreServices.bes.',
    'coreServices.defaultsms.',
    'coreServices.gridbean.',
    'container.externalregistry.autodiscover',
    'container.security.attributes.VO-PUSH.',
    'sms.protocols',
    'DEFAULT.protocols',
    'container.registry.globalAdvertise',
    
    
            
# property values
    'de.fzj.unicore.bes.util.BESOnStartup',
    'de.fzj.unicore.uas.util.CreateSMSOnStartup',
    'com.intel.gpe.gridbeans.PublishGridBeanService',        
]

#
# updated property names
#
updated = {'XNJS.staging.filesystem.grace' : 'XNJS.staging.filesystemGraceTime'}

#
# delete these values
#
delete = [ 'de.fzj.unicore.bes.util.BESOnStartup',
           'de.fzj.unicore.uas.util.CreateSMSOnStartup',
           'com.intel.gpe.gridbeans.PublishGridBeanService',
]

def handle(name,value):
    for ign in ignored:
        if ign in name or ign in value:
            print ("*** skipping (obsolete): %s=%s" % (name, value), file=sys.stderr)
            return
    
    name = updated.get(name, name)
    print ("%s=%s" % (name, value))

def load_properties(filepath):
    props = {}
    with open(filepath, "rt") as f:
        for line in f:
            l = line.strip()
            if l and not l.startswith('#'):
                key_value = l.split('=')
                key = key_value[0].strip()
                value = '='.join(key_value[1:]).strip().strip('"') 
                props[key] = value 
    return props


namespaces = {'eng' : 'http://www.fz-juelich.de/unicore/xnjs/engine',
       'use': 'http://www.fz-juelich.de/unicore/wsrflite' }

elements = ['./eng:Properties/eng:Property',
           './use:property', 'property'
          ]

try:
    # parse as XML
    tree = ET.parse(file)
    root = tree.getroot()
    for expr in elements:
        for prop in root.findall(expr, namespaces):
            name = prop.attrib['name']
            value = prop.attrib['value']
            handle(name,value)

except:
    # parse as plain properties
    with open(file, "r") as f: 
        for line in f:
            l = line.strip()
            if l and not l.startswith('#'):
                key_value = l.split('=')
                name = key_value[0].strip()
                value = '='.join(key_value[1:]).strip().strip('"') 
                handle(name,value)

