In this lesson, we'll talk about breaking a common workflow down into smaller pieces.  Using the knowledge we gained from previous lessons, we'll build a small script for each piece of the workflow.  Finally, we'll string these small scripts together at the linux command-line in order to rebuild our workflow.

## Scenario:

An IP phone user has called to report problems with their audio.  They are unable or unwilling to provide any additional information about their phone, besides their extension number.  Our goal over this lesson is to find the name of the access switch and the interface that their phone is attached to.

In this first step, we've created a small script to retrieve the IP address of a phone from an IP PBX, given the extension number of the phone.  

## Start Soft Phone Client

Before we run this script, we'll have to start the SIP phone software located on the 'sipphone' box.  Click the button below to do this.

```
cd /antidote
./phone.sh
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('sipphone', this)">Run this snippet</button>

OK, the phone is now registered to the PBX.  To see this yourself, hit enter in the 'sipphone' tab.  You should see that account 2 has a status of OK/200.  This means the phone is registered to the PBX.
In this case, the phone has extension 1107 assigned to it.

## Querying For The Next Troubleshooting Clue

Now let's get the IP of the phone by querying the SIP PBX.  Click the button below.

```
cd /antidote
./get-phone-ip-from-ext.py --host=asterisk --port=8088 --username=admin --password=admin --phone=1107
```
<button type="button" class="btn btn-primary btn-sm" onclick="runSnippetInTab('linux1', this)">Run this snippet</button>

This seems simple, but is already very a very powerful tool. For many enterprise customers, getting the IP address of a software or hardware client such as a phone, a virtual-machine host, a chat client, or a storage element can be difficult and time consuming. Having a script such as this where you can pass in non-network data, such as the extension number, to retrieve network data, such as an IP, can save time and frustration!

In future versions of this lesson, we'll explore the use of this data to link with other pieces of infrastructure data, to build our troubleshooting journey.

