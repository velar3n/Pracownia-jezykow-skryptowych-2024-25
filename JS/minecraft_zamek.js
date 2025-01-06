let wallHeight = 0
let windowHeight = 0
let wallLength = 0
function buildFloor () {
    builder.mark()
    for (let index = 0; index < 19; index++) {
        builder.move(FORWARD, 38)
        builder.turn(LEFT_TURN)
        builder.turn(LEFT_TURN)
        builder.move(LEFT, 1)
        builder.move(FORWARD, 38)
        builder.turn(LEFT_TURN)
        builder.turn(LEFT_TURN)
        builder.move(RIGHT, 1)
    }
    builder.move(FORWARD, 38)
    builder.tracePath(BLACK_GLAZED_TERRACOTTA)
}
function buildWalls () {
    for (let index = 0; index < 4; index++) {
        buildWall()
        buildTower()
        builder.move(FORWARD, 1)
        builder.move(LEFT, 1)
    }
    builder.move(DOWN, 1)
    builder.move(BACK, 4)
    builder.move(LEFT, 2)
    buildFloor()
}
function buildTower () {
    wallHeight = 15
    windowHeight = 3
    builder.move(FORWARD, 1)
    builder.move(RIGHT, 1)
    builder.turn(LEFT_TURN)
    builder.mark()
    for (let index = 0; index < 4; index++) {
        builder.move(FORWARD, 4)
        builder.turn(RIGHT_TURN)
    }
    builder.raiseWall(CHISELED_TUFF, wallHeight)
    builder.move(RIGHT, 4)
    builder.move(UP, 8)
    builder.move(FORWARD, 1)
    builder.mark()
    builder.move(UP, windowHeight)
    builder.move(FORWARD, 1)
    builder.move(DOWN, windowHeight)
    builder.move(FORWARD, 1)
    builder.move(UP, windowHeight)
    builder.tracePath(GLASS_PANE)
    builder.move(LEFT, 4)
    builder.move(BACK, 3)
    builder.move(DOWN, 8)
    builder.move(DOWN, windowHeight)
    builder.turn(RIGHT_TURN)
    builder.turn(RIGHT_TURN)
}
function buildWall () {
    wallLength = 30
    wallHeight = 10
    builder.mark()
    builder.move(FORWARD, wallLength)
    builder.move(LEFT, 1)
    builder.move(BACK, wallLength)
    builder.move(LEFT, 1)
    builder.move(FORWARD, wallLength)
    builder.raiseWall(TUFF, wallHeight)
    builder.move(UP, wallHeight)
    builder.mark()
    builder.move(BACK, wallLength)
    builder.raiseWall(TUFF_WALL, 1)
    builder.move(RIGHT, 2)
    builder.mark()
    builder.move(FORWARD, wallLength)
    builder.raiseWall(TUFF_WALL, 1)
    builder.move(DOWN, wallHeight)
}
player.onChat("buildCastle", function () {
    buildWalls()
})