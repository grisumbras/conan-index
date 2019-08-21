<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <title><%block name="title"/></title>
    <link rel="stylesheet" href="m-dark.css">
    <link rel="stylesheet" href="styles.css">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="theme-color" content="#22272e">
  </head>
  <body>
    <main>
      <div class="m-container">
        <div class="m-row">
          <article class="m-col-m-10 m-push-m-1">
            ${self.body()}
          </article>
        </div>
      </div>
    </main>
  </body>
</html>
