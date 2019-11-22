<script>
  let renderedView;
  let currentView;
  let viewSelect;
  export let viewOptions;

  function handleSelectClick() {
    viewSelect.click();
  }

  function getHeaders() {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'X-Requested-With': 'XMLHttpRequest'
    }
  }

  async function changeView() {
    const response = await fetch('/councillors/christy-burke/votes',
    {
      method: 'GET'
    });

    console.log(response);
  }
</script>

<style>
</style>

<nav class="view-subnav switcher-nav">
  <div class="mobile-subnav">
    <div role="layout" class="wrapper">
      <div class="switcher">
        <select bind:this={viewSelect} bind:value={currentView} on:change={changeView}>
          <option>Votes</option>
          <option>Attendance</option>
          <option>Proposed motions</option>
          <option>Proposed amendments</option>
        </select>
      </div>
    </div>
  </div>
  <div class="desktop-nav">
    <div role="layout" class="wrapper">
      <div class="subnav-items">
        <div class="subnav-item -current">
          <a href="/">Votes</a>
        </div>
      </div>
    </div>
  </div>
</nav>

<div class="view-partial switcher-view">
  <div role="layout" class="wrapper">
    <div class="loader"><p>Loading&hellip;</div>
  </div>
</div>