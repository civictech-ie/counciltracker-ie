import AdminMenu from '../admin-menu.svelte';
import Switcher from '../switcher.svelte';
import Attendance from '../attendance.svelte';
import Vote from '../vote.svelte';
import WebpackerSvelte from "webpacker-svelte";
import Turbolinks from "turbolinks";
import Rails from '@rails/ujs';

Turbolinks.start();
Rails.start();
WebpackerSvelte.setup({ AdminMenu, Switcher, Attendance, Vote });