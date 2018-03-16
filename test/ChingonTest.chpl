use Chingon,
    Charcoal;

class ChingonTest : UnitTest {
  proc init() {
    super.init();
  }

  proc setUp(){}
  proc tearDown() {}

  proc testConstructors() {
    var nv: int = 8,
        D: domain(2) = {1..nv, 1..nv},
        SD: sparse subdomain(D),
        X: [SD] real;

    var graphName = "Vato";
    var vn: [1..0] string;
    vn.push_back("star lord");
    vn.push_back("gamora");
    vn.push_back("groot");
    vn.push_back("drax");
    vn.push_back("rocket");
    vn.push_back("mantis");
    vn.push_back("yondu");
    vn.push_back("nebula");

    SD += (1,2); X[1,2] = 1;
    SD += (1,3); X[1,3] = 1;
    SD += (1,4); X[1,4] = 1;
    SD += (2,2); X[2,2] = 1;
    SD += (2,4); X[2,4] = 1;
    SD += (3,4); X[3,4] = 1;
    SD += (4,5); X[4,5] = 1;
    SD += (5,6); X[5,6] = 1;
    SD += (6,7); X[6,7] = 1;
    SD += (6,8); X[6,8] = 1;
    SD += (7,8); X[7,8] = 1;

    var g = new Graph(X=X, name=graphName, directed = false, vnames=vn);
    assertStringEquals("Graph gets a name", expected=graphName, actual=g.name);
    assertBoolEquals("Graph gets directed", expected=false, actual=g.directed);
    assertIntEquals("Graph has 8 vertices", expected=8, actual=g.vcount());

    const vns = g.verts.keys.sorted();
    assertStringEquals("First entry is 'drax'", expected="drax", actual=vns[1]);
    assertStringEquals("Fourth entry is 'mantis'", expected="mantis", actual=vns[4]);

    const nbs = g.neighbors("star lord");
    assertBoolEquals("'Star Lord' neighbors 'groot'", expected=true
      , actual=nbs.keys.member("groot"));
    assertBoolEquals("'Star Lord' does not neighbor 'rocket'", expected=false
      , actual=nbs.keys.member("rocket"));

    const dgs: [1..nv] real = [3.0, 1.0, 1.0, 1.0, 1.0, 2.0, 1.0, 0.0];
    assertArrayEquals("Graph has correct degrees", expected=dgs, actual=g.degree());
    assertIntEquals("'Star Lord' has correct degree", expected=3, actual=g.degree('star lord'));

    const ef: [1..nv] real = [3.0, 1.0, 1.0, 1.0, 1.0, 2.0, 1.0, 0.0];
    assertArrayEquals("Graph has correct flow", expected=ef, actual=g.flow());

    const sef: [1..nv] real = [2.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0];
    const seft: [1..nv] real = [2.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
    const v = g.flow(vs={"star lord", "gamora", "drax"}, interior=true);
    writeln(sef);
    writeln(v);
    assertArrayEquals("Subgraph {'star lord', 'gamora', 'drax'}' has correct flow (interior false)"
      , expected=sef, actual=g.flow(vs={"star lord", "gamora", "drax"}, interior=false));

    assertArrayEquals("Subgraph {'star lord', 'gamora', 'drax'}' has correct flow (interior true)"
      , expected=seft, actual=g.flow(vs={"star lord", "gamora", "drax"}, interior=true));
  }

  proc run() {
    testConstructors();
    return 0;
  }
}

proc main(args: [] string) : int {
  var t = new ChingonTest();
  var ret = t.run();
  t.report();
  return ret;
}
