<%inherit file="layout.mako"/>


<%def name="link(x)">
  <a href="${x}">${x}</a>
</%def>


<%block name="title">Conan Package Index</%block>


<h1>Conan Package Index</h1>

<ul id="package-list">
  % for group in package_groups:
    <li class="package-block m-note m-primary">
      <h3>${group.name}:${group.namespace}</h3>
      <p class="package-description">${group.description}</p>
      % if group.topics:
        Topics:
        <ul>
          % for topic in group.topics:
            <li>${topic}</li>
          % endfor
        </ul>
      % endif
      <dl class="package-attributes">
        % if group.homepage:
          <dt>Project hompepage</dt><dd>${link(group.homepage)}</dd>
        % endif
        % if group.url:
          <dt>Package homepage</dt><dd>${link(group.url)}</dd>
        % endif
        <dt>License</dt><dd>${group.license or "proprietary"}</dd>
        % if group.author:
          <dt>Author</dt><dd>${group.author}</dd>
        % endif
        <dt>Packages</dt>
        <dd>
          <ol>
            % for package in group.packages:
              <li>
                ${package.reference()}
                (from <a href="#remote-${package.remote.name}">${package.remote.name}</a>)
              </li>
            % endfor
          </ol>
        </dd>
      </dl>
    </li>
  % endfor
</ul>

<h2>Remotes</h2>
<ul>
  % for remote in remotes:
    <li id="remote-${remote.name}">${remote.name} ${remote.url}</li>
  % endfor
</ul>
