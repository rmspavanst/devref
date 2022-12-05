#!/usr/bin/python
# -*- coding: utf-8 -*-

# Copyright: (c) 2020, Alex Willmer <alex@moreati.org.uk>
# Apache 2.0 license

ANSIBLE_METADATA = {
    'metadata_version': '1.1',
    'status': 'preview',
}

DOCUMENTATION = '''
module: psutil_kill

short_description: Kill processes
description:
  - "Kill running processes"

options:
  pids:
    description:
      - IDs of processes to be killed
    type: list
    elements: int
    required: true

requirements:
  - psutil Python package

seealso:
  - module: pids

author:
    - Alex Willmer (@moreati)
'''

EXAMPLES = '''
- name: Kill an unlucky process
  psutil_kill:
    pids: 13

- name: Kill several unlucky processes
  psutil_kill:
    pids:
      - 13
      - 14
      - 15
'''

RETURN = '''
killed:
  description: The processes that were killed
  type: list
  elements: dict
  sample:
    - pid: 123
    - pid: 456
  returned: on success
'''

import traceback

from ansible.module_utils.basic import AnsibleModule, missing_required_lib

try:
    import psutil
    HAS_PSUTIL = True
except ImportError:
    HAS_PSUTIL = False
    PSUTIL_IMP_TRACEBACK = traceback.format_exc()


def run_module():
    module_args = {
        'pids': {'type': 'list', 'elements': 'int', 'default': []},
    }

    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=True,
    )

    if not HAS_PSUTIL:
        module.fail_json(
            msg=missing_required_lib('psutil'),
            exception=PSUTIL_IMP_TRACEBACK,
        )

    processes_killed = []
    for pid in module.params['pids']:
        try:
            process = psutil.Process(pid)
            if not module.check_mode:
                process.kill()
        except psutil.NoSuchProcess:
            continue
        processes_killed.append({"pid": pid})

    module.exit_json(
        changed=bool(processes_killed),
        killed=processes_killed,
    )


def main():
    run_module()


if __name__ == '__main__':
    main()
