window.addEventListener("scroll", setScrollVar)
window.addEventListener("resize", setScrollVar)
function setScrollVar() { 
    const htmlElement = document.documentElement
    const percentOfScreenScrolled = htmlElement.scrollTop/htmlElement.clientHeight // 0 ~ number of pages that we have 
    console.log(percentOfScreenScrolled * 100)
    htmlElement.style.setProperty("--scroll", percentOfScreenScrolled * 100) // first let's say 3 pages ==> from 0 ~ 300 
}

setScrollVar()