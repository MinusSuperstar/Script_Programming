function makeEdges(block: number, ox: number, oy: number, oz: number, x: number, y: number, z: number) {

    // Bottom
    blocks.fill(block, pos(ox, oy, oz), pos(ox + x, oy, oz), FillOperation.Replace)
    blocks.fill(block, pos(ox, oy, oz + z), pos(ox + x, oy, oz + z), FillOperation.Replace)
    blocks.fill(block, pos(ox, oy, oz), pos(ox, oy, oz + z), FillOperation.Replace)
    blocks.fill(block, pos(ox + x, oy, oz), pos(ox + x, oy, oz + z), FillOperation.Replace)

    // Top
    blocks.fill(block, pos(ox, oy + y, oz), pos(ox + x, oy + y, oz), FillOperation.Replace)
    blocks.fill(block, pos(ox, oy + y, oz + z), pos(ox + x, oy + y, oz + z), FillOperation.Replace)
    blocks.fill(block, pos(ox, oy + y, oz), pos(ox, oy + y, oz + z), FillOperation.Replace)
    blocks.fill(block, pos(ox + x, oy + y, oz), pos(ox + x, oy + y, oz + z), FillOperation.Replace)

    // Vertical edges
    blocks.fill(block, pos(ox, oy, oz), pos(ox, oy + y, oz), FillOperation.Replace)
    blocks.fill(block, pos(ox + x, oy, oz), pos(ox + x, oy + y, oz), FillOperation.Replace)
    blocks.fill(block, pos(ox, oy, oz + z), pos(ox, oy + y, oz + z), FillOperation.Replace)
    blocks.fill(block, pos(ox + x, oy, oz + z), pos(ox + x, oy + y, oz + z), FillOperation.Replace)
}

function makeWindows(ox: number, oy: number, oz: number, x: number, z: number, floorY: number) {

    let winW = 5 
    let winH = 2

    let y = oy + floorY

    let midZ = Math.floor(z / 2)
    let startZ = oz + midZ - Math.floor(winW / 2)

    for (let i = 0; i < winW; i++) {
        for (let j = 2; j < winH+2; j++) {
            blocks.place(GLASS_PANE, pos(ox, y + j, startZ + i))
        }
    }

    for (let i = 0; i < winW; i++) {
        for (let j = 2; j < winH+2; j++) {
            blocks.place(GLASS_PANE, pos(ox + x, y + j, startZ + i))
        }
    }
}

player.onChat("castle", function () {

    let floor_number = 2
    let y = 6
    let x = 12
    let z = 16

    let ox = 20 
    let oy = 0
    let oz = 20

    let floor = "oak_planks"

    // Walls
    blocks.fill(
        STONE_BRICKS,
        pos(ox, oy, oz),
        pos(ox + x, oy + y * floor_number, oz + z),
        FillOperation.Hollow
    )

    // floors
    for (let i = 0; i < floor_number; i++) {

        blocks.fill(
            blocks.blockByName(floor),
            pos(ox + 1, oy + i * y, oz + 1),
            pos(ox + x - 1, oy + i * y, oz + z - 1),
            FillOperation.Replace
        )
        makeWindows(ox, 0, oz, x, z, i * y)
        makeEdges(LOG_OAK, ox, oy, oz, x, y * (i + 1), z)
    }

    // Roof
    for (let i = 0; i <= x / 2; i++) {
        blocks.fill(
            BRICKS,
            pos(ox + i, oy + y * floor_number + i, oz),
            pos(ox + x - i, oy + y * floor_number + i, oz + z),
            FillOperation.Replace
        )
    }

    // entrance
    let gateWidth = 5
    let gateHeight = 5
    let midX = Math.floor(x / 2)
    let startX = ox + midX - Math.floor(gateWidth / 2)

    for (let i = 0; i < gateWidth; i++) {
        for (let j = 0; j < gateHeight; j++) {
            if (j==0)
                blocks.place(blocks.blockWithData(STONE_BRICK_STAIRS,2), pos(startX + i, oy + j, oz))
            else
                blocks.place(AIR, pos(startX + i, oy + j, oz))
        }
    }

})
