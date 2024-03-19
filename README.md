# Rup-Delivery

Rup-Delivery is a free delivery script designed to copy the style found in GTA Online.

<div class="image-container">
    <img src="https://media.discordapp.net/attachments/1043860724419670026/1219526704507129916/image.png?ex=660b9fc0&is=65f92ac0&hm=25d3d173b94b2ddc55363f8a7d815ca962f028be2e02351948cf70fe638c2361&=&format=webp&quality=lossless&width=550&height=309" alt="Image 1">
    <img src="https://media.discordapp.net/attachments/1043860724419670026/1219526757959598292/image.png?ex=660b9fcc&is=65f92acc&hm=57b9b258a90d669a4375c2a469752008a0f78e7bf9963d75bebfe3adfd1d8d67&=&format=webp&quality=lossless&width=550&height=309" alt="Image 2">
    <!-- Add more image tags here -->
</div>

<style>
    .image-container {
        display: flex;
        flex-wrap: wrap;
        gap: 10px; /* Adjust the gap between images */
    }

    .image-container img {
        max-width: calc(50% - 5px); /* Make each image take up 50% of the container width with a little gap */
        height: auto;
    }
</style>
## Features

- Realistic delivery job mechanics inspired by GTA Online.
- Configurable payout ranges for completed deliveries.
- Compatibility with both qb-core and ESX frameworks.
- Debugging options.

## Installation

2. Clone or download the Rup-Delivery repository.
3. Place the script files in the appropriate server resource directory.
4. Update the `config.lua` file to configure payout ranges and framework preferences.
5. Ensure that the necessary dependencies (`qb-core` or `ESX`) are installed and configured properly.
6. Ensure Rup-Delivery resource in your server.cfg file.
7. Restart or start your FiveM server.

## Usage

- Players can trigger the delivery duty event (`rup-delivery:delivery_duty`) to start their delivery job.
- Once on duty, they can complete deliveries, which trigger the `rup-delivery:delivery_complete` event.
- Payouts are randomized based on configured payout ranges and added to the player's bank account.
- Debugging messages are printed in the server console for monitoring and troubleshooting.

## Configuration

- Payout ranges and framework preferences can be configured in the `config.lua` file.
- Adjust the payout ranges to balance the economy of your server.
- Choose between the `qb-core` or `ESX` framework based on your server's setup.

## Dependencies

- [qb-core](https://github.com/qbcore-framework/qb-core) or [ESX](https://github.com/esx-framework)

## Credits

Rup-Delivery is maintained and supported by [Ruptz](https://github.com/ruptz).

## License

This project is licensed under the [MIT License](LICENSE).