import java.util.Vector;

import TUIO.TuioCursor;

public interface Touchable {
  public boolean touchOne(Vector<TuioCursor> cursors);
  public boolean touchTwo(Vector<TuioCursor> cursors);
  public boolean touchThree(Vector<TuioCursor> cursors);
  public boolean touchAboveFour(Vector<TuioCursor> cursors);
}
