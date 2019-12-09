<script>
  export let links, currentView, basePath, renderedView;
  export let redirect = false;

  let loadingPromise;

  $: if (currentView != renderedView) {
    if (redirect) {
      Turbolinks.visit(`${basePath}/${currentView}`);
    } else {
      loadingPromise = rerenderView(currentView);
      renderedView = currentView;
    }
  }

  async function rerenderView(view) {
    const viewEl = document.getElementById("switcherView");

    viewEl.innerHTML = `<div class="loader"><div class="wrapper" role="layout">Loading&hellip;</div></div>`;

    const res = await fetch(`${basePath}/${view}/partial`, {
      'headers': {
        "Content-Type": "application/js"
      }});
    const newView = await res.text();

    if (res.ok) {
      history.pushState({},'',`${basePath}/${view}`)
      viewEl.innerHTML = newView;
    } else {
      throw new Error(res.statusText);
    }
  }
</script>

<style>
</style>

<nav class="switcher-nav">
  <div class="mobile-subnav">
    <div role="layout" class="wrapper">
      <div class="switcher">
        <select bind:value={currentView}>
          {#each links as { view, label }}
            <option value="{view}" selected={ view === currentView }>{label}</option>
          {/each}
        </select>
      </div>
    </div>
  </div>
  <div class="desktop-nav">
    <div role="layout" class="wrapper">
      <div class="subnav-items">
        {#each links as { view, label }}
          <div class="subnav-item" class:current={ view === currentView }>
            <a href={basePath + '/' + view} on:click|preventDefault={ e => (currentView = view) }>{label}</a>
          </div>
        {/each}
      </div>
    </div>
  </div>
</nav>