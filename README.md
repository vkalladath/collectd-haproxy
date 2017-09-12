collectd-haproxy
================
This is a collectd plugin to pull HAProxy (<http://haproxy.1wt.eu>) stats from the HAProxy management socket.
It is written in Python and as such, runs under the collectd Python plugin.

Requirements
------------

*HAProxy*  
To use this plugin, HAProxy must be configured to create a management socket with the `stats socket`
configuration option. collectd must have read/write access to the socket.

*collectd*  
collectd must have the Python plugin installed. See (<http://collectd.org/documentation/manpages/collectd-python.5.shtml>)

Options
-------
* `ProxyMonitor`  
Proxy to monitor. If unset, defaults to ['server', 'frontend', 'backend'].
Specify multiple times to specify additional proxies
* `Socket`
File location of the HAProxy management socket

Install
-------
1. Copy this repository to `/usr/share/collectd/collectd-haproxy`
2. Create a collectd configuration for the plugin file in If you installed collectd using the signalfx installer, you should place your the haproxy configuration file in the `/etc/collectd/managed_config/` directory.  See the example configuration below.
3. `SELINUX ONLY` Create a SELinux policy package using the supplied type enforcement file.  Enter the commands below to create and install the policy package.
```bash 
$ cd /usr/share/collectd/collectd-haproxy/selinux
$ checkmodule -M -m -o collectd-haproxy.mod collectd-haproxy.te
checkmodule:  loading policy configuration from collectd-haproxy.te
checkmodule:  policy configuration loaded
checkmodule:  writing binary representation (version 17) to collectd-haproxy.mod
$ semodule_package -o collectd-haproxy.pp -m collectd-haproxy.mod
$ sudo semodule -i collectd-haproxy.pp
$ sudo reboot
```
4. Restart collectd

Example
-------
```apache
    <LoadPlugin python>
        Globals true
    </LoadPlugin>

    <Plugin python>
        # haproxy.py is at /usr/share/collectd/collectd-haproxy/haproxy.py
        ModulePath "/usr/share/collectd/collectd-haproxy"

        Import "haproxy"

        <Module haproxy>
          # Some versions of haproxy expose the socket in "/var/lib/haproxy/stats"
          Socket "/var/run/haproxy.sock"
          Interval 10
          EnhancedMetrics "False"
          ProxyMonitor "server"
          ProxyMonitor "backend"
          # ExcludeMetric "requests"
          # ExcludeMetric "session_limit"
        </Module>
    </Plugin>
```
