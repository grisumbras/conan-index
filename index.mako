<!doctype html>
<html>
  <head>
  </head>
  <body>
    <h1>Conan Package Index</h1>
    % for remote in data:
      <h2>${remote.name} (${remote.url})</h2>
      <ul>
        % for package in remote.packages:
          <li>${package["recipe"]["id"]}</li>
        % endfor
      </ul>
    % endfor
  </body>
</html>
