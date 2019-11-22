<script>
  let open = false;

  function toggleOpen() {
    open = !!!open
  }
</script>

<style>
</style>

<div class="mobile-header">
  <div class="logo"><a href="/">CouncilTracker.ie</a></div>

  <a on:click={toggleOpen} class="toggle" class:open>
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 30 24">
      <rect width="30" height="24" style="fill:none"/>
      {#if open}
        <line x1="3.85" y1="0.85" x2="26.15" y2="23.15"/>
        <line x1="26.15" y1="0.85" x2="3.85" y2="23.15"/>
      {:else}
        <line x1="0.63" y1="12" x2="29.38" y2="12"/>
        <line x1="0.63" y1="22.64" x2="29.38" y2="22.64"/>
        <line x1="0.63" y1="1.36" x2="29.38" y2="1.36"/>
      {/if}
    </svg>
  </a>
</div>

{#if open}
  <div class="mobile-nav">
    <div class="text-block">
      <ul class="p -t1">
        <li><a href="/motions">Motions</a></li>
        <li><a href="/councillors">Councillors</a></li>
        <li><a href="/meetings">Meetings</a></li>
      </ul>
    </div>
    <div class="footer-block">
      <ul class="p -t4">
        <li><a href="/faq">FAQs</a></li>
        <li><a href="/submit-correction">Submit correction</a></li>
        <li><a href="https://www.github.com/civictech-ie/counciltracker-ie">Source code</a></li>
      </ul>
      <div class="p -t4">
        <p>A project by <br/><a href="https://www.dublininquirer.com">Dublin Inquirer</a><br/>and <a href="https://www.civictech.ie">CivicTech.ie</a>.</p>
      </div>
    </div>
  </div>
{/if}