RobyAI
======

<p><b>RobyAI</b> is very very simple AI program</p>
<p>The project is created for the "Programming with Ruby" course
at the Sofia University, 2015</p>

Running configuration
=====================

<ol>
<li>
You must first install the ActiveRecord gem using the command <blockquote>gem install activerecord</blockquote>
</li>
<li>
After that, you must install the corresponding database adapter for active record. For example, I'm using MS SQL Server so i install the sqlserver adapter using the command <blockquote>gem install activerecord-sqlserver-adapter</blockquote>
</li>
<li>
Now, install the tiny_tds gem by typing the command
<blockquote>gem install tiny_tds</blockquote>
<b>Important:</b> If you are using <b>Windows OS</b>, you must install the gem with the --pre attribute:
<blockquote>gem install tiny_tds --pre</blockquote>
</li>
<li>
Then create and change the <i>'Settings/local_settings.rb'</i> file, so it can point to your local database settings
</li>
<li>
Finally, you start the <b>main.rb</b> file, which will load all the required files.
</li>
<li>
If you want to test the code with the given tests, you should install the gem DatabaseCleaner. It helps to clean after some of the tests
<blockquote>gem install database_cleaner</blockquote>
</li>
</ol>
