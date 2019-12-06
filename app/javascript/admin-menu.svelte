<script>
  let open = false;

  function toggleOpen() {
    open = !!!open
  }
</script>

<style>
</style>

<div class="mobile-header">
  <div class="logo"><a href="/admin">Admin</a></div>

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
        <li><a href="/admin/meetings">Meetings</a></li>
        <li><a href="/admin/councillors">Councillors</a></li>
        <li><a href="/admin/events">Events</a></li>
      </ul>
    </div>
    <div class="footer-block">
      <ul class="p -t4">
        <li><a href="/admin/corrections">Corrections</a></li>
        <li><a href="/">Back to public site</a></li>
        <li><a href="/logout">Log out</a></li>
      </ul>
    </div>
  </div>
{/if}