# jquery-github-repo
[![Build Status](https://secure.travis-ci.org/bpaulin/jquery-github-repo.png?branch=master)](http://travis-ci.org/bpaulin/jquery-github-repo)

jquery plugin to populate a html element with github repositories and [coderwall] badges

```html
<div id="jquery-github-repo">
    <!-- a div.badges will be filled with coderwall badges -->
    <div class="badges"></div>
    <!-- a div.repositories will contain github repos -->
    <div class="repositories">
        <!-- it will use a div.repository for each repo -->
        <!-- if a div.repository with the right data-github-full-name is found  -->
        <div class="repository" data-github-full-name="user/repo1">
            <!-- it will not erase the content -->
            this text describes repo1
        </div>
    </div>
</div>
<script>
    $( function() {
        $( '.jquery-github-repo' ).githubRepo( {
            /* user, for github AND coderwall */
            user: 'user',
            /* process github repositories */
            github: true,
            /* add every repos of user, not only those found in div.repositories */
            allGithubRepos: true,
            /* process coderwall badges */
            coderwall: true,
            /* if specified, it will use this json for github */
            githubForceJson : false,
            /* if specified, it will use this json for coderwall */
            coderwallForceJson : false,
        });
    } );
</script>
```

[coderwall]: https://coderwall.com/

