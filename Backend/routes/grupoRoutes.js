const express = require("express");
const router = express.Router();
const gc = require("../controllers/grupoController");

router.get("/", gc.getAllGroups);
router.post("/", gc.createGroupV2);
router.post("/agregarUsuario", gc.addUser);
router.get("/usuarios/:usuario_id", gc.getMyGroups);
router.get("/:grupo_id/usuarios", gc.getMembers);
router.delete("/usuario", gc.removeUser);
router.delete("/:id", gc.deleteGroup);

module.exports = router;
