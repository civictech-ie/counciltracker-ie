import Menu from '../menu.svelte';
import Switcher from '../switcher.svelte';
import WebpackerSvelte from "webpacker-svelte";
import Turbolinks from "turbolinks";
import Rails from '@rails/ujs';

Turbolinks.start();
Rails.start();
WebpackerSvelte.setup({ Menu, Switcher });