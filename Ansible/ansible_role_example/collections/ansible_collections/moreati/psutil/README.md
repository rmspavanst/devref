# psutil Collections for Ansible

This Ansible collection includes Ansible modules for managing processes
with the [psutils](https://pypyi/project/psutils) package.

## Included

### Modules

- psutil_kill

## Installation

```sh
ansible-galaxy collection install moreati.psutil
```

## Example

```yaml
- name: Exercise psutil
  hosts: localhost
  gather_facts: false
  tasks:
    - shell:
        cmd: |
          echo $$
          sleep 20 &
          echo $!
      register: sleepers

    - moreati.psutil.psutil_kill:
        pids: "{{ sleepers.stdout_lines }}"
      register: killers
