document.addEventListener("turbolinks:load", function() {
  // # 背景色を変える
  document.querySelectorAll("td").forEach(function(td) {
    td.addEventListener("mouseover", function(e) {
      e.currentTarget.style.backgroundColor = "#eff";
    });

    td.addEventListener("mouseout", function(e) {
      e.currentTarget.style.backgroundColor = "";
    });
  });
});

// 削除したタスクを非表示に
// document.addEventListener("turbolinks:load", function() {
//   document.querySelectorAll(".delete").forEach(function(a) {
//     console.log("Event listener added to an element with class 'delete'");
//     a.addEventListener("ajax:success", function() {
//       console.log("ajax:success event fired");
//       var td = a.parentNode;
//       var tr = td.parentNode;
//       tr.style.display = "none";
//     });
//   });
// });
