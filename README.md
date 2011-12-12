Overview
========

Every Chef installation needs a Chef Repository. This is the place where cookbooks, roles, config files and other artifacts for managing systems with Chef will live. We strongly recommend storing this repository in a version control system such as Git and treat it like source code.

While we prefer Git, and make this repository available via GitHub, you are welcome to download a tar or zip archive and use your favorite version control system to manage the code.

Project-Specific Notes
======================

In the interest of speedy development, and grokable specifications for new contributors, we'll be using the [Librarian rubygem](https://github.com/applicationsonline/librarian). Librarian allows us to easily specify the cookbook versions in a flat text file that's used to generate the `cookbooks` directory after cloning the chef-repo. (`cookbooks` itself is added to the `.gitignore`.) These cookbooks can be pulled in from either the Opscode Community site, individual git repositories, or from the local filesystem (in our case, the local filesystem is within our own chef-repo, not outside). Further documentions is available in [Librarian's README on GitHub](https://github.com/applicationsonline/librarian).

Here are the current conventions for managing this chef-repo:

1. On the master branch, the whole of the `cookbooks` directory is generated dynamically from `Cheffile.lock`, which is derived from `Cheffile`.

2. `cookbooks-overrides` directory is used to store simple, file-specific overrides to otherwise established and stable external cookbooks from the community site or github. (It essentially bypasses Librarian management for simple customizations, pulling in overrides at the Chef/Knife level by using the secondary reference in the [`cookbook_path` setting of `knife.rb`](https://github.com/FLOSolutions/fga-chef-repo/tree/master/.chef/knife.rb#L16).) This is most appropriate for less complex changes to files and additions of any new files (recipes, templates, files, etc.). We'll need to carefully scrutinize these files when updating corresponding cookbooks in `Cheffile.lock`. If overrides are extensive, it may make sense to fork the external cookbook and pull in our own, but this should be avoided where possible. 

3. `cookbooks-sources` directory is used to place git submodules that will be pulled into the dynamically-generated `cookbooks` directory using the `:path` attribute in the `Cheffile`. It is intended for custom cookbooks (especially those that are more actively developed), and (on master) its submodules should always reference tagged commits. While it is arguably better to simply pull in the tagged cookbooks from within the `Cheffile` via the `:git` attribute, this would act as a layer of indirection when viewing the chef-repo on github. We want our custom cookbooks to be most easily accessible, and [github's feature of linking submodules](https://github.com/blog/154-submodule-display) is much preferable to a flat reference in `Cheffile`. 

Further, every effort will be made to tag all actively developed cookbooks according to [semantic versioning specifications](http://semver.org/).

During development, every effort will be made to use the [maximum version control strategy](http://www.opscode.com/blog/2011/04/21/chef-0-10-preview-environments/).

Also, every effort with be made to make cookbook creation follow a [README-driven development process](http://tom.preston-werner.com/2010/08/23/readme-driven-development.html), as espoused in [Joshua Timberman's excellent article](http://jtimberman.github.com/blog/2011/09/03/guide-to-writing-chef-cookbooks/) on cookbook development strategies.

The ruby DSL will be avoided in favour of version-controlling the raw JSON format for roles, environments, etc. The rationale for this approach is so that changes made via the web UI (or any method that doesn't involve explicit editting of files as the primary means of change), can still be captured in version control in a meaningful manning. Uncaptured changes can be pulled into an appropriate format using a command comparable to this:

`knife environment development --format=json > environments/development.json`

This approach to version control may be scripted into a rake command at a later date, so that uncaptured changes (for example, made by a non-technical user through the web UI) may be easily captured in version control.

We have yet to develop a clear strategy for managing environments.
Ideally, this strategy will involve semantic versioning on the chef-repo
itself (to allow any build to be tagged with metadata for not only
application components, but server configuration as well). It should
also ideally involve access-control for environments based on git
branches, so that per-branch access can be more accessible for future
testing and development environments. This will leave an opportunity for
even more transparency and automation, allow any low-level contributor
to push config changes and have them tested in an automated fashion in a
sandboxed environment.

It may be the case that our access-control requirements may not work
with the actual Environment construct build into Chef.

# Recommended Development Approach

Established cookbooks, regardless of how project-specific they may seem,
should be hosted as external cookbooks. This allows not only for tagged
semantic versioning, but also for a clearer commit history. If the repo
is public, it also makes it that much simpler to fork and contribute to
the effort.

The naming convention should be `chef-APP_NAME`. Try to consider
future namespacing conflicts. For instance, don't name a cookbook
`chef-logmein` is you're developing for Logmein Hamachi, as cookbooks
for other product suites are possible.

When cookbooks are cloned into chef-repo's, the intention is that
users will strip the `chef-` prefix, so ensure that all internal
refernces refer to the cookbook by that name. In other words, generate
cookbook skeletons with this command:

`knife cookbook create APP_NAME -r md`

(It is recommended that you generate the README in markdown format, as
opposed to rdoc.)

When it makes sense to have an isolated development environment for a
cookbook, it is recommended that you follow a Librarian-centric
approach in creating a [Vagrant](http://www.vagrantup.com) development environment. This approach is explained more fully in the [`freight-cooking` repo](https://github.com/patcon/freight-cooking). This will help to keep everyone working on cookbooks in consistent, shareable, and version-controlled environments.

Repository Directories
======================

This repository contains several directories, and each directory contains a README file that describes what it is for in greater detail, and how to use it for managing your systems with Chef.

* `certificates/` - SSL certificates generated by `rake ssl_cert` live here.
* `config/` - Contains the Rake configuration file, `rake.rb`.
* `cookbooks/` - Cookbooks you download or create.
* `data_bags/` - Store data bags and items in .json in the repository.
* `roles/` - Store roles in .rb or .json in the repository.

Rake Tasks
==========

The repository contains a `Rakefile` that includes tasks that are installed with the Chef libraries. To view the tasks available with in the repository with a brief description, run `rake -T`.

The default task (`default`) is run when executing `rake` with no arguments. It will call the task `test_cookbooks`.

The following tasks are not directly replaced by knife sub-commands.

* `bundle_cookbook[cookbook]` - Creates cookbook tarballs in the `pkgs/` dir.
* `install` - Calls `update`, `roles` and `upload_cookbooks` Rake tasks.
* `ssl_cert` - Create self-signed SSL certificates in `certificates/` dir.
* `update` - Update the repository from source control server, understands git and svn.

The following tasks duplicate functionality from knife and may be removed in a future version of Chef.

* `metadata` - replaced by `knife cookbook metadata -a`.
* `new_cookbook` - replaced by `knife cookbook create`.
* `role[role_name]` - replaced by `knife role from file`.
* `roles` - iterates over the roles and uploads with `knife role from file`.
* `test_cookbooks` - replaced by `knife cookbook test -a`.
* `test_cookbook[cookbook]` - replaced by `knife cookbook test COOKBOOK`.
* `upload_cookbooks` - replaced by `knife cookbook upload -a`.
* `upload_cookbook[cookbook]` - replaced by `knife cookbook upload COOKBOOK`.

Configuration
=============

The repository uses two configuration files.

* config/rake.rb
* .chef/knife.rb

The first, `config/rake.rb` configures the Rakefile in two sections.

* Constants used in the `ssl_cert` task for creating the certificates.
* Constants that set the directory locations used in various tasks.

If you use the `ssl_cert` task, change the values in the `config/rake.rb` file appropriately. These values were also used in the `new_cookbook` task, but that task is replaced by the `knife cookbook create` command which can be configured below.

The second config file, `.chef/knife.rb` is a repository specific configuration file for knife. If you're using the Opscode Platform, you can download one for your organization from the management console. If you're using the Open Source Chef Server, you can generate a new one with `knife configure`. For more information about configuring Knife, see the Knife documentation.

http://help.opscode.com/faqs/chefbasics/knife

Next Steps
==========

Read the README file in each of the subdirectories for more information about what goes in those directories.

License and Contributors
========================

Contributor:: Patrick Connolly <patrick.c.connolly@gmail.com>

Copyright 2011, FLOSolutions

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
