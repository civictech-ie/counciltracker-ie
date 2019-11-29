<script>
  export let links, currentView, basePath, renderedView;

  $: if (currentView != renderedView) {
    const viewEl;
    // viewEl = document.getElementById("switcher-view");
    // viewEl.innerHTML = '';
  }

  // async function changeView() {
  //   const response = await fetch(`${basePath}/votes`,
  //   {
  //     method: 'GET'
  //   });

  //   console.log(response);
  // }
</script>

<style>
</style>

<nav class="view-subnav switcher-nav">
  {currentView}
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