{% if page.comments && theme.gitalk.enable %}
  <link href="https://cdn.bootcdn.net/ajax/libs/gitalk/1.6.2/gitalk.min.css" rel="stylesheet">
  <script src="https://cdn.bootcdn.net/ajax/libs/gitalk/1.6.2/gitalk.min.js"></script>
  <script type="text/javascript">
      var gitalk = new Gitalk({
        clientID: '{{ theme.gitalk.client_id }}',
        clientSecret: '{{ theme.gitalk.client_secret }}',
        repo: '{{ theme.gitalk.github_repo }}',
        owner: '{{ theme.gitalk.github_user }}',
        admin: ['{{ theme.gitalk.admin }}'],
        id: location.pathname,
        distractionFreeMode: '{{ theme.gitalk.distraction_free_mode }}'
      })
      gitalk.render('gitalk-container')           
  </script>
{% endif %}