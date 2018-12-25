module.exports = { create, read, update, del }

function Hero(name, archenemy, loveinterest){
	var hero = { name: name, archEnemy: archenemy, loveInterest: loveinterest}
	return hero
}

var fakeDB = [
	Hero("Sarah Connor", "SkyNet", "Kyle Reese"),
	Hero("Luke Skywalker", "Darth Vader", "Leia Organa"),
	Hero("Buffy Summers", "The Master", "Angel"),
	Hero("Hamlet", "Claudius", "Ophelia"),
	Hero("Charly Baltimore", "Leland Perkins", "Hal"),
	Hero("Batman", "Joker", "Robin")
]

function matches(a, b) {
	var result = true
	for (var prop in a) {
		if (a[prop] && b[prop]!==a[prop]) {
			result = false
			break
		}
	}
	return result
}

function create(hero){
	fakeDB.push(hero)
	return { ServerMsg: "Row created"}
}

function read(query){
	var result = []
	for (var hero of fakeDB) {
		if (matches(query,hero)) result.push(hero)
	}
	return result
}

function update(query){
	var result = []
	var count = 0
	for (var hero of fakeDB) {
		if (hero.name===query.name) {
			for (var prop in query) {
				if (query[prop]) hero[prop]=query[prop]
			}
			count++
		}
		result.push(hero)
	}
	fakeDB = result
	return { ServerMsg: count + " row(s) updated"}
}

function del(query){
	var result = []
	var count = 0
	for (var hero of fakeDB) {
		if (matches(query,hero)) {
			count++
		} else {
			result.push(hero)
		}
	}
	fakeDB = result
	return { ServerMsg: count + " row(s) deleted"}
}

