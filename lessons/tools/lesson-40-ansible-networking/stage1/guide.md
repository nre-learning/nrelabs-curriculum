# Ansible for Network Automation
## Part 1 - Your First Playbook Run

Navigate to lesson stage directory and show inventory:

```
cd /antidote/stage1
cat devices
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx1', this)">Run this snippet</button>


Next, show playbook contents:

```
cat playbook.yml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx1', this)">Run this snippet</button>

Finally test playbook execution

```
ansible-playbook -i devices playbook.yml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx1', this)">Run this snippet</button>
