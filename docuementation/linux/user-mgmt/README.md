


# The `useradd` software

# The `groupadd` software


<article>
<h1 itemprop="headline">Linux groupadd command</h1>
<div class="updated">Updated: <span itemprop="dateModified" content="2019-05-04">05/04/2019</span> by <span itemprop="author publisher creator" itemscope="" itemtype="https://schema.org/Organization"><span itemprop="name">Computer Hope</span></span></div>
<img src="/cdn/linux/groupadd.gif" alt="groupadd command" class="floatRight" width="300" height="300"><p class="intro">On <a href="/jargon/u/unix-like.htm">Unix-like</a> operating systems, the <b>groupadd</b> command creates a new group.</p>
<p>This document describes the <a href="/jargon/g/gnu.htm">GNU</a>/<a href="/jargon/l/linux.htm">Linux</a> version of <b>groupadd</b>.</p>
<div class="pagenav contents">
<ul>
<li><a href="#desc">Description</a></li>
<li><a href="#syntax">Syntax</a></li>
<li><a href="#examples">Examples</a></li>
<li><a href="#related">Related commands</a></li>
<li class="out"><a href="/unix.htm">Linux commands help</a></li>
</ul>
</div>
<h2 id="desc">Description</h2>
<p class="tab">The <b>groupadd</b> command creates a new <a href="/jargon/g/group.htm">group</a> account using the values specified on the <a href="/jargon/c/commandi.htm">command line</a> plus the default values from the system. The new group will be entered into the system files as needed.</p>
<h2 id="syntax">Syntax</h2>
<pre class="tcy tab">groupadd [<i>options</i>] <i>group</i></pre>
<h2>Options</h2>
<table class="mtable3 tab">
<tbody><tr class="tcw">
<td><p><b>-f, --force</b></p></td>
<td><p>This option causes the command to exit with success status if the specified group already exists. When used with <b>-g</b>, and the specified GID already exists, another (unique) GID is chosen (i.e. <b>-g</b> is turned off).</p></td>
</tr>
<tr class="tcw">
<td><p><b>-g, --gid</b> <i>GID</i></p></td>
<td><p>The numerical value of the group's ID. This value must be unique, unless the <b>-o</b> option is used. The value must be non-negative. The default is to use the smallest ID value greater than or equal to <b>GID_MIN</b> and greater than every other group.</p>
<p>See also the <b>-r</b> option and the <b>GID_MAX</b> description.</p>
</td>
</tr>
<tr class="tcw">
<td><p><b>-h</b>, <b>--help</b></p></td>
<td><p>Display help message and exit.</p></td>
</tr>
<tr class="tcw">
<td><p><b>-K</b>, <span style="white-space:nowrap"><b>--key</b> <i>KEY=VALUE</i></span></p></td>
<td><p>Overrides <b>/etc/login.defs</b> defaults (<b>GID_MIN</b>, <b>GID_MAX</b> and others). Multiple <b>-K</b> options can be specified.</p>
<p>Example: <b>-K GID_MIN=100 -K GID_MAX=499</b></p>
</td>
</tr>
<tr class="tcw">
<td><p><b>-o,</b> <i>--non-unique</i></p></td>
<td><p>This option permits to add a group with a non-unique GID.</p></td>
</tr>
<tr class="tcw">
<td><p><b>-p</b>, <span style="white-space:nowrap"><b>--password</b> <i>PASSWORD</i></span></p></td>
<td><p>The <a href="/jargon/e/encrypt.htm">encrypted</a> <a href="/jargon/p/password.htm">password</a>, as returned by the <b>crypt()</b> system call. The default is to disable the password.</p>
<p><b>Note:</b> This option is not recommended because the password (or encrypted password) will be visible by users listing the processes. You should make sure the password respects the system's password policy.</p>
</td>
</tr>
<tr class="tcw">
<td><p><b>-r</b>, <b>--system</b></p></td>
<td><p>Create a system group. The numeric identifiers of new system groups are chosen in the <b>SYS_GID_MIN-SYS_GID_MAX</b> range, defined in <b>login.defs</b>, instead of <b>GID_MIN-GID_MAX.</b></p></td>
</tr>
<tr class="tcw">
<td><p><b>-R</b>, <span style="white-space:nowrap"><b>--root</b> <i>CHROOT_DIR</i></span></p></td>
<td><p>Apply changes in the <b>CHROOT_DIR</b> directory and use the configuration files from the <b>CHROOT_DIR</b> directory. See also <a href="/jargon/c/chroot.htm"><b>chroot</b></a>.</p></td>
</tr>
</tbody></table>
<h2>Configuration</h2>
<p class="tab">The following configuration variables in <b>/etc/login.defs</b> change the behavior of this tool:</p>
<p class="tab"><b>GID_MAX</b> <i>(number)</i>, <b>GID_MIN</b> <i>(number)</i></p>
<p class="tab">Range of group IDs used for the creation of regular groups by <a href="/unix/useradd.htm">useradd</a>, groupadd, or <b>newusers</b>. The default value for <b>GID_MIN</b> (resp. <b>GID_MAX</b>) is <b>1000</b> (resp. <b>60000</b>).</p>
<p class="tab"><b>MAX_MEMBERS_PER_GROUP</b> <i>(number)</i></p>
<p class="tab">Maximum members per <a href="/jargon/g/group.htm">group</a> entry. When the maximum is reached, a new group entry (line) is started in <b>/etc/group</b> (with the same name, same password, and same GID). The default value is <b>0</b>, meaning that there are no limits in the number of members in a group. This feature (split group) permits to limit the length of lines in the group file. This is useful to make sure that lines for NIS groups are not larger than 1024 characters. If you need to enforce such limit, you can use <b>25</b>. <b>Note:</b> split groups may not be supported by all tools (even in the Shadow toolsuite). You should not use this variable unless you really need it.</p>
<p class="tab"><b>SYS_GID_MAX</b> <i>(number)</i>, <b>SYS_GID_MIN</b> <i>(number)</i></p>
<p class="tab">Range of group IDs used for the creation of system groups by <a href="/unix/useradd.htm">useradd</a>, groupadd, or <b>newusers</b>. The default value for <b>SYS_GID_MIN</b> (resp. <b>SYS_GID_MAX</b>) is <b>101</b> (resp. <b>GID_MIN-1</b>).</p>
<h2 id="examples">Examples</h2>
<div class="tip">
<span class="title">Tip</span>
<p>For this command to work you must have superuser rights or be logged in as <a href="/jargon/r/root.htm">root</a>.</p>
</div>
<pre class="tcy tab">groupadd newgroup</pre>
<p class="tab">The above example would create a new group called <b>"newgroup"</b>. This new group could then have users added to it using the <a href="/unix/useradd.htm"><b>useradd</b></a> command.</p>
<h2 id="related">Related commands</h2>
<p class="tab"><a href="/unix/gpasswd.htm"><b>gpasswd</b></a> — Administer /etc/group and /etc/gshadow.<br><a href="/unix/groupdel.htm"><b>groupdel</b></a> — Remove a group from the system.<br><a href="/unix/groupmod.htm"><b>groupmod</b></a> — Modify a group definition.<br><a href="/unix/useradd.htm"><b>useradd</b></a> — Add a user to the system.</p>
</article>
