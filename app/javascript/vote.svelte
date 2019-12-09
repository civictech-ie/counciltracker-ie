<script>
  export let councillorId, voteableId, voteableType, status, name;
  let saving = false;
  let localStatus = status;

  const statuses = ['for', 'against', 'abstain', 'absent', 'not_voted', 'exception'];

  $: if (!saving && (localStatus != status)) {
    saveChange();
  }

  async function saveChange() {
    saving = true;

    const res = await fetch(`/admin/${voteableType.toLowerCase()}s/${voteableId}/save_vote`, {
      method: 'post',
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({councillorId, status})
    });
    
    const resJson = await res.json();

    if (res.ok) {
      localStatus = status;
      console.log(resJson['message']);
    } else {
      throw new Error(resJson);
    }

    saving = false;
  }
</script>

<div class="enumerable -councillor -vote">
  <div class="content -smaller">
    <div class="name">{name}</div>
  </div>
  <div class="detail -bigger">
    {#each statuses as statusOption}
      <label>
        <input type="radio" bind:group={status} value={statusOption} />
        {statusOption}
      </label>
    {/each}
  </div>
</div>