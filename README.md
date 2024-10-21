# HG-VehRental
 

## Description
The HG-VehRental script allows players to rent vehicles with a dynamic pricing system. The system integrates seamlessly with **ESX** and **QB Core** frameworks. This script provides a simple and customizable rental system with refund options upon return, vehicle deletion, and compatibility with **OX Lib** for enhanced functionality.

## Preview
https://imgur.com/JLcYyZ6

### **Key Features**
- **Vehicle Rental System**: Rent vehicles with dynamic pricing and plate management.
- **Refundable Rentals**: Option for players to receive a refund when returning the vehicle.
- **QB and ESX Framework Compatibility**: Works with both **ESX** and **QB Core**.
- **OX Lib Integration**: Utilizes **OX Lib** for efficient target zones and callback handling.
- **Custom Blips and NPCs**: Add custom rental NPCs and blips to your server.
- **Plate Verification**: Ensure only rented vehicles can be returned.

### **Usage**
After installing, you can configure vehicle rental locations, available vehicles, and pricing through the `Config` file. Players can rent vehicles via NPC interactions and return them for refunds if configured.

## Installation
1. Place the `HG-VehRental` folder in your `resources` directory.
2. Add the following to your `server.cfg`:
   ```lua
   ensure HG-VehRental
   ```
3. Install the required dependencies (OX Lib).


## Dependencies
This script relies on the following resources:
- **ESX** or **QB Core** framework.
- **OX Lib** - [Ox lib](https://github.com/overextended/ox_lib/releases/)

## Technical Support
For technical support, please join the Discord: [HG Store Discord](https://discord.gg/9E2VCwp9uk)
