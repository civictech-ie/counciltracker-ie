<script>
  export let links, currentView, basePath, renderedView;
  let loadingPromise;

  $: if (currentView != renderedView) {
    loadingPromise = rerenderView(currentView);
    renderedView = currentView;
    // viewEl.innerHTML = '';
  }

  async function rerenderView(view) {
    const viewEl = document.getElementById("switcherView");
    const initialHeight = viewEl.clientHeight;

    viewEl.innerHTML = `<div class="loader" style="height:${initialHeight}px">Loading&hellip;</div>`;

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