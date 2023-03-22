# security-onion
Configure the infrastructure needed to work with Security Onion 2 on AWS

Creates a Kali instance and an Analyst VM instance

Create the infrastructure using Terraform.

Connect to Onion server and follow the [Installation Instructions](https://docs.securityonion.net/en/2.3/installation.html). Recommendations are as follows:

https://user-images.githubusercontent.com/3796667/226188017-89548a42-2a18-478e-87df-35a08aeec555.mov



**Users and passwords for GUI Desktop:**

**Security Onion 2**

* Login = ubuntu
* Password = Passw0rd

**SANS SIFT Workstation**

* Login = sansforensics
* Password = forensics

**REMnux**

* Login = remnux
* Password = malware

**Kali Linux**

* Login = kali
* Password = Passw0rd

**Windows Server**

* Login = Administrator
* Password = Passw0rd

**Note**: _You have the option of changing the password run running terraform apply_