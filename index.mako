<!doctype html>
<html>
  <head>
  </head>
  <body>
    <h1>Conan Package Index</h1>
    <ul>
      % for group in data["package_groups"]:
        <li>
          <h3>${group.name}:${group.namespace}</h3>
          <p>${group.description}</p>
          % if group.topics:
            Topics:
            <ul>
              % for topic in group.topics:
                <li>${topic}</li>
              % endfor
            </ul>
          % endif
          <dl>
            % if group.homepage:
              <dt>Project hompepage</dt><dd>${group.homepage}</dd>
            % endif
            % if group.url:
              <dt>Package homepage</dt><dd>${group.url}</dd>
            % endif
            <dt>License</dt><dd>${group.license or "proprietary"}</dd>
            <dt>Author</dt><dd>${group.author or "-"}</dd>
          </dl>
          Packages:
          <ol>
            % for package in group.packages:
              <li>
                ${package.reference()}
                (from <a href="#remote-${package.remote.name}">${package.remote.name}</a>)
              </li>
            % endfor
          </ol>
        </li>
      % endfor
    </ul>
    <h2>Remotes</h2>
    <ul>
      % for remote in data["remotes"]:
        <li id="remote-${remote.name}">${remote.name} ${remote.url}</li>
      % endfor
    </ul>
  </body>
</html>
