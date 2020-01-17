# Ansible for Network Automation
**Contributed by: [Red Hat Ansible](https://www.redhat.com/en/technologies/management/ansible)**
---

## Part 1 - Your First Playbook Run

Navigate to lesson stage directory and show inventory:

```
cd /antidote/stage1
cat devices
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('ansible', this)">Run this snippet</button>


Next, show playbook contents:

```
cat playbook.yml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('ansible', this)">Run this snippet</button>

Run our simple playbook to update the login banner on the vqfx:

```
ansible-playbook -i devices playbook.yml
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('ansible', this)">Run this snippet</button>

We can verify this is done on the vqfx:

```
show configuration system login message
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('vqfx1', this)">Run this snippet</button>

Give the Cumulus VX some love :)

```
echo "Hello I'm here too!"
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('cvx1', this)">Run this snippet</button>
